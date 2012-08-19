Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2HSKUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:20:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54355 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2HSKUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:20:50 -0400
Message-ID: <5030BC7E.3030000@gmail.com>
Date: Sun, 19 Aug 2012 12:14:22 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
References: <1345333117-2826-1-git-send-email-mail@danrl.de>  <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com> <1345371135.4441.2.camel@tunafish>
In-Reply-To: <1345371135.4441.2.camel@tunafish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2012 12:12, Dan Luedtke ha scritto:
> (resent)
> On Sun, 2012-08-19 at 00:16 +0200, richard -rw- weinberger wrote:
>> What are the use cases of this filesystem?
>> It looks very minimal without much features.
> That's the feature, actually. Think of the Arduino platform or other embedded devices (TV, Car Entertainment) that just want to read/play files. You're right, no big features, but that's by design.
>
> Dan
>

You say that you wrote a new fs because of some lacks in the other fs 
("...I kind of invented a very simple filesystem that solves the issues 
I had with other filesystems...."). I read the website (very quickly 
actually) but I didn't find the point: what are pros and cons of this fs 
compared with existing fs? What problems does it solve?

Marco
