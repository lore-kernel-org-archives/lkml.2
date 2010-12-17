Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0LQOHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:07:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0LQOHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:07:46 -0500
Date: Fri, 17 Dec 2010 09:06:06 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu,
        tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        vst@vlnb.net, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
        linux-ide@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        James.Bottomley@suse.de, Sergei Shtylyov <sshtylyov@mvista.com>,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, rwheeler@redhat.com, swhiteho@redhat.com,
        chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
Subject: Re: training mpath to discern between SCSI errors
Message-ID: <20101217140605.GA740@redhat.com>
References: <20100825155918.GB8509@redhat.com>
 <4C7B984E.4070802@suse.de>
 <4C7B9F14.9080900@mvista.com>
 <4C7BA670.2060303@suse.de>
 <4C7BC5B4.3010707@suse.de>
 <4CBC00B3.7090603@ce.jp.nec.com>
 <4CBC35AE.9050002@suse.de>
 <20101119031149.GA28455@us.ibm.com>
 <20101130225956.GA8882@redhat.com>
 <4D0B31B5.101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0B31B5.101@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17 2010 at  4:47am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 11/30/2010 11:59 PM, Mike Snitzer wrote:
> > Hannes,
> > 
> > Any chance you've had time to fold your proposed logging changes in and
> > rebase this patch?  Could you post that updated patch?
> > 
> yes, will be following shortly.
> 
> > I'd like to help see this patch through to inclussion when 2.6.38 merge
> > window opens.  I can help with further review, testing and development.
> > 
> Ok, thanks.

I took some steps at furthering your work.  Here is the cover letter to
the patches I resently sent to dm-devel:
https://www.redhat.com/archives/dm-devel/2010-December/msg00090.html

And here are the patches:
https://patchwork.kernel.org/patch/384612/
https://patchwork.kernel.org/patch/384602/
https://patchwork.kernel.org/patch/390882/

Please feel free to change these how ever you see fit but your feedback
is really appreciated.

Thanks,
Mike
