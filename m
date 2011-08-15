Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1HOBB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 21:01:56 -0400
Received: from ozlabs.org ([203.10.76.45]:58999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1HOBBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 21:01:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] virtio-net: Use virtio_config_val() for retrieving config
In-Reply-To: <1313333553-23086-3-git-send-email-levinsasha928@gmail.com>
References: <1313333553-23086-1-git-send-email-levinsasha928@gmail.com> <1313333553-23086-3-git-send-email-levinsasha928@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 15 Aug 2011 10:28:05 +0930
Message-ID: <87pqk77aoy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011 17:52:33 +0300, Sasha Levin <levinsasha928@gmail.com> wrote:
> This patch modifies virtio-net to use virtio_config_val() instead
> of a 'if(virtio_has_feature()) vdev->config->get()' construct to retrieve
> optional values from the config space.

Thanks, all applied.

Cheers,
Rusty.
