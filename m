Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2LSKrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2LSKrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:47:36 -0500
Date: Wed, 19 Dec 2012 11:47:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
 buffers
Message-ID: <20121219104722.GA5832@stefanha-thinkpad.redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
 <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
> +/**
> + * virtqueue_start_buf - start building buffer for the other end
> + * @vq: the struct virtqueue we're talking about.
> + * @buf: a struct keeping the state of the buffer
> + * @data: the token identifying the buffer.
> + * @count: the number of buffers that will be added

Perhaps count should be named count_bufs or num_bufs.

> + * @count_sg: the number of sg lists that will be added

What is the purpose of count_sg?

Stefan
