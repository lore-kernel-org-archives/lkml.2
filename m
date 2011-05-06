Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1EFO3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:29:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55416 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1EFO3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:29:14 -0400
Message-ID: <4DC405B0.1020905@kernel.dk>
Date: Fri, 06 May 2011 08:29:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Subject: Re: [PATCH 00/16] cciss: May 3, 2011 updates
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-03 13:52, Stephen M. Cameron wrote:
> The following series mostly contains fixes to improve kdump behavior
> and esp. to make older controllers which cannot be hard reset work by
> doing a soft reset instead.   There are a few patches factoring out
> various functionality into individual functions make way for the soft
> reset functionality.  There is also a bugfix which prevents PCI write
> combining from potentially causing commands to get lost. 

Applied to for-2.6.40/drivers


-- 
Jens Axboe

