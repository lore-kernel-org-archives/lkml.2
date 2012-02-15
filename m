Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2BOX6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:58:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32989 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2BOX6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:58:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
	<CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
Date: Wed, 15 Feb 2012 18:58:12 -0500
Message-ID: <CAOULuObKZX_VER0ERPNBb0gS8GBQBHpJBHQcpJi2kNBBysL=2A@mail.gmail.com>
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
From: Parag Warudkar <parag.lkml@gmail.com>
To: Egmont Koblinger <egmont@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 1:50 PM, Egmont Koblinger <egmont@gmail.com> wrote:
> Hi,
>
> Short summary:  When pasting large amount of data (>4kB) to terminals,
> often the data gets mangled.
>
> How to reproduce:
> Create a text file that contains this line about 100 times:
> a=(123456789123456789123456789123456789123456789123456789123456789)
> (also available at http://pastebin.com/LAH2bmaw for a while)
> and then copy-paste its entire contents in one step into a "bash" or
> "python" running in a graphical terminal.
>

FWIW, this also works fine on cygwin / Windows 7.  No errors.

$ bash --version
GNU bash, version 4.1.10(4)-release (i686-pc-cygwin)

Unsure what that means though - probably nothing!

Greg - when you said it works in vim - since of course vim isn't
'parsing' the input may be you did not see an error - or did you
actually verify all 4KB somehow? ;)

Parag
