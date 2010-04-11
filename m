Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0DKPE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 11:04:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0DKPEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 11:04:24 -0400
Message-ID: <4BC1E4A4.1070103@redhat.com>
Date: Sun, 11 Apr 2010 18:03:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ben Gamari <bgamari.foss@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, tytso@mit.edu, npiggin@suse.de,
       mingo@elte.hu, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>	<20100327204233.0d84542a@infradead.org>	<4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>	<87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
In-Reply-To: <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 05:56 PM, Ben Gamari wrote:
> On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen<andi@firstfloor.org>  wrote:
>    
>> Ben Gamari<bgamari.foss@gmail.com>  writes:
>> ext4/XFS/JFS/btrfs should be better in this regard
>>
>>      
> I am using btrfs, so yes, I was expecting things to be better. Unfortunately,
> the improvement seems to be non-existent under high IO/fsync load.
>
>    

btrfs is known to perform poorly under fsync.

-- 
error compiling committee.c: too many arguments to function

