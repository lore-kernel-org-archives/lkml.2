Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0DIO4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:56:34 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:36700 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0DIO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=wXtvAxaUVbexDnVxM0LoQ/aTY8FgGhX259l1tVW5ImmUqnewppkO4vVz+SO3gBOUg2
         oum3UL3HJECOsdk77RXC/Eg5y48UrVHCoAD41Toa3ONNt26uw49t7PA6m3L3oE6WpbhW
         0Jh5QzDpF78+s+uuQNwdhEadfhmOqTDfxZLE0=
Message-ID: <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
Date: Fri, 09 Apr 2010 07:56:30 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tytso@mit.edu, npiggin@suse.de, mingo@elte.hu,
       Ruald Andreae <ruald.a@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
In-Reply-To: <87y6hcyu85.fsf@basil.nowhere.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
	<20100327204233.0d84542a@infradead.org>
	<4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>
	<87y6hcyu85.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Ben Gamari <bgamari.foss@gmail.com> writes:
> ext4/XFS/JFS/btrfs should be better in this regard
> 
I am using btrfs, so yes, I was expecting things to be better. Unfortunately, 
the improvement seems to be non-existent under high IO/fsync load.

- Ben

