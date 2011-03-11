Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1CKTJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:09:06 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47571 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab1CKTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:09:05 -0500
Message-ID: <4D7A734F.1060008@kernel.dk>
Date: Fri, 11 Mar 2011 20:09:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH] cciss: export resettable host attribute
References: <20110310202326.30581.9475.stgit@beardog.cce.hp.com>
In-Reply-To: <20110310202326.30581.9475.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 21:23, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> This attribute, requested by Redhat, allows kexec-tools to know
> whether the controller can honor the reset_devices kernel parameter
> and actually reset the controller.  For kdump to work properly it
> is necessary that the reset_devices parameter be honored.  This
> attribute enables kexec-tools to warn the user if they attempt to
> designate a non-resettable controller as the dump device.

Applied.

-- 
Jens Axboe

