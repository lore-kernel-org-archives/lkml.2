Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1AKJ6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:58:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37174 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab1AKJ57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:57:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q9GbelNkMLXTPgtuVGGcO+Ji9JQSIRs4lS0uLyTFPD6vKpJ0Xm1deLBFppBjGbqq/e
         JTnG4sZoc5H430SD69gXXTjSeRjjf3vNcKe34IwpPoeohQHmw6o4eE4Fw0fNfb+7GEd3
         nYUCGGA35h+UgDCP/z4ZJ+SMZE/bcC1f0QV4M=
MIME-Version: 1.0
In-Reply-To: <4D282A17.4040104@gmail.com>
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<4D282A17.4040104@gmail.com>
Date: Tue, 11 Jan 2011 20:57:58 +1100
Message-ID: <AANLkTikJjL6XEDJiYSh_J_rT+5LRUNj5EKDzCQ-852D7@mail.gmail.com>
Subject: Re: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 January 2011, Marco Stornelli <marco.stornelli@gmail.com> wrote:
> Il 08/01/2011 03:54, Nick Piggin ha scritto:
>> The vfs-scale branch is now upstream. If you haven't
>> looked yet, your filesystem is likely to have been
>> touched, so check it out.
>>
>> Also look at Documentation/filesystems/porting and
>> path-lookup.txt.
>
> Nick, in the porting file I read:
>
> ..........hazards on dentries and inodes (see
> Documentation/filesystems/path-walk.txt). ..........
>  ^^^^^^^^^^^^^
>
> Should it be "path-lookup.txt"?
>
> Marco
>

Hi, yes thanks I'll fix it
