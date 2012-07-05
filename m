Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2GEGrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab2GEGru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:47:50 -0400
Message-ID: <4FF5388C.5010306@redhat.com>
Date: Thu, 05 Jul 2012 08:47:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>  <1341419217.18786.3.camel@lappy> <4FF47023.7080206@redhat.com> <1341436285.18786.6.camel@lappy>
In-Reply-To: <1341436285.18786.6.camel@lappy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 23:11, Sasha Levin ha scritto:
> There are two things going on here:
>  1. Rename VIRTIO_BLK_F_FLUSH to VIRTIO_BLK_F_WCE
>  2. Add a new VIRTIO_BLK_F_CONFIG_WCE
> 
> I'm concerned that the first change is going to break compilation for
> any code that included linux/virtio-blk.h and used VIRTIO_BLK_F_FLUSH.

That would be nlkt, right? :)

We can add back VIRTIO_BLK_F_FLUSH as a synonym then.

Paolo
