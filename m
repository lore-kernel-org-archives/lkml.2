Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2BJAhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:37:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48275 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2BJAhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:37:32 -0500
Message-ID: <4F3466C7.7030804@gmail.com>
Date: Thu, 09 Feb 2012 17:37:27 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, acme@redhat.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v6 16/18] perf: enable reading of perf.data files from
 different ABI rev
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-17-git-send-email-eranian@google.com>
In-Reply-To: <1328826068-11713-17-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/2012 03:21 PM, Stephane Eranian wrote:
> This patch allows perf to process perf.data files generated
> using an ABI that has a different perf_event_attr struct size, i.e.,
> a different ABI version.
> 
> The perf_event_attr can be extended, yet perf needs to cope with
> older perf.data files. Similarly, perf must be able to cope with
> a perf.data file which is using a newer version of the ABI than
> what it knows about.
> 
> This patch adds read_attr(), a routine that reads a perf_event_attr
> struct from a file incrementally based on its advertised size. If
> the on-file struct is smaller than what perf knows, then the extra
> fields are zeroed. If the on-file struct is bigger, then perf only
> uses what it knows about, the rest is skipped.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: David Ahern <dsahern@gmail.com>

