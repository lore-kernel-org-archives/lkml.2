Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1HaSrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 14:47:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53853 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1HaSrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 14:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
References: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
	<CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
Date: Wed, 31 Aug 2011 14:47:13 -0400
Message-ID: <CACqU3MV9nd-0i3Ng7rFCFRFnw1Wii0V4PJcx0U_AmxanJQoS6g@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 fixes for 3.1-rc5
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 31, 2011 at 2:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Aug 31, 2011 at 10:46 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> Please pull from:
>>
>>        git://github.com/tytso/ext4.git for_linus-20110831 # 8c0bec2151a
>>
>> to get the following bug fix.  It address a lockdep warning which a lot
>> of people have been complaining about.
>
> So what's up? Bad English and a github address makes me unhappy.
>
> I can imagine that you decided not to use kernel.org due to hera being
> down, but this still makes me want to say "please more references".
>
shouldn't all pull request be digitally signed, by _default_ ?

 - Arnaud
