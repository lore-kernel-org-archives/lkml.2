Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab1ANS5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851Ab1ANS5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:57:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Alberto Mattea <alberto@mattea.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata_nv silently ignores discard (TRIM) command?
References: <201101141850.25252@alby>
	<x49mxn39vzm.fsf@segfault.boston.devel.redhat.com>
	<201101141936.11923@alby>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 14 Jan 2011 13:57:45 -0500
In-Reply-To: <201101141936.11923@alby> (Alberto Mattea's message of "Fri, 14
	Jan 2011 19:36:11 +0100")
Message-ID: <x49fwsv9uty.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Mattea <alberto@mattea.info> writes:

> In data venerdì 14 gennaio 2011 19:32:45, Jeff Moyer ha scritto:
>> 
>> What does 'cat /sys/block/sda/queue/discard_zeroes_data' say?
>> 
>> Cheers,
>> Jeff
> Hi Jeff, it says 0. So I assume it's not working?

That means that discarded blocks are not zeroed.  The trim was likely
processed just fine.

Cheers,
Jeff
