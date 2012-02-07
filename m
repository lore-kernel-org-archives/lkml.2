Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2BGOxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab2BGOxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:53:12 -0500
Date: Tue, 7 Feb 2012 12:52:21 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v5 16/18] perf: enable reading of perf.data files from
	different ABI rev
Message-ID: <20120207145220.GM6367@infradead.org>
References: <1328187288-24395-1-git-send-email-eranian@google.com> <1328187288-24395-17-git-send-email-eranian@google.com> <20120206182208.GH6367@infradead.org> <4F30CCA6.4040001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F30CCA6.4040001@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 12:33:02PM +0530, Anshuman Khandual escreveu:
> On Monday 06 February 2012 11:52 PM, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Feb 02, 2012 at 01:54:46PM +0100, Stephane Eranian escreveu:
> >> This patch allows perf to process perf.data files generated
> >> using an ABI that has a different perf_event_attr struct size, i.e.,
> >> a different ABI version.

> > Anshuman, can I have your Acked-by or Reviewed-by since you spotted
> > problems in this and your suggestions were taken into account? Is this
> > OK now?

> (1) PERF_SAMPLE_BRANCH_HV and related privilege level problems has been fixed. 
>     Verified various combinations of <branch_type>,[u,k,hv] <event>:[u,k,h].
>     Works well in all privilege level permutations.
> 
> (2) As Peter has mentioned 'has_branch_smpl()' bug in the ARM code would be taken
>     care.
> 
> (3) 'ref_size' problem in try_all_pipe_abis() has been fixed. All the patches 
>     independently compile successfully.
> 
> (4) Went through the entire patchset, looks good to me. 
> 
> Acked-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> Tested-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

Thanks! But we'll now have to wait till Stephane addresses the points
made by David :-)

- Arnaldo
