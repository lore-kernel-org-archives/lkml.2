Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab0KPMvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:51:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab0KPMvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:51:01 -0500
Date: Tue, 16 Nov 2010 07:50:16 -0500
From: Josef Bacik <josef@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-5-git-send-email-josef@redhat.com> <4CE2783F.1020004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2783F.1020004@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:25:35PM +0200, Avi Kivity wrote:
> On 11/15/2010 07:05 PM, Josef Bacik wrote:
>> Ext4 doesn't have the ability to punch holes yet, so make sure we return
>> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
>> be added later.  Thanks,
>>
>
> Instead of teaching filesystems to fail if they don't support the  
> capability, why don't supporting filesystems say so, allowing the fail  
> code to be in common code?
>

There is no simple way to test if a filesystem supports hole punching or not so
the check has to be done per fs.  Thanks,

Josef
