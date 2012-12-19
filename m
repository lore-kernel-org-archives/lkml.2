Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2LSL1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2LSL12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:27:28 -0500
Date: Wed, 19 Dec 2012 12:27:18 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20121219112718.GB5832@stefanha-thinkpad.redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
 <1355833972-20319-6-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355833972-20319-6-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 01:32:52PM +0100, Paolo Bonzini wrote:
>  struct virtio_scsi_target_state {
> -	/* Never held at the same time as vq_lock.  */
> +	/* This spinlock ever held at the same time as vq_lock.  */

s/ever/is never/
