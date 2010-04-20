Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0DTUIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:08:38 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:51894 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab0DTUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:08:36 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 16:08:36 EDT
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
In-Reply-To: <4BCC68BF.6090300@gmail.com> (Alexander E. Patrakov's message of
	"Mon, 19 Apr 2010 20:29:19 +0600")
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
	<4BCC68BF.6090300@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 20 Apr 2010 15:56:00 -0400
Message-ID: <m37ho1x5hz.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:100420:linux-kernel@vger.kernel.org::TJ166oGkj/zCpP17:00000000000000000000000000000000Ha6+E
X-Hashcash: 1:30:100420:patrakov@gmail.com::AJXHGvdDxTC+QeU4:0000000000000000000000000000000000000000000DGJN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AEP" == Alexander E Patrakov <patrakov@gmail.com> writes:

AEP> Since KOI7 is not used by any glibc locale, your use case is now
AEP> extinct. I think that, unless someone finds out a different use case,
AEP> these SI and SO characters should be deactivated completely (and not
AEP> just in unicode mode).

SI/SO is also relevant for line draw characters and the like.

Here is a key for the default set in my (X11) term emulator,
I presume it is the same as what the console supports:

 _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~
 ▮ ◆ ▒ ␉ ␌ ␍ ␊ ° ± ␤ ␋ ┘ ┐ ┌ └ ┼ ⎺ ⎻ ─ ⎼ ⎽ ├ ┤ ┴ ┬ │ ≤ ≥ π ≠ £ ·

Those are important, and the console should continue to support them
even when not in UTF-8 mode.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
