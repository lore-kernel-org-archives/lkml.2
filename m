Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1BHJcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:32:12 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43972 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1BHJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:32:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=sqqAu+3zCGifJjqM9ylzzGtSUs79304Ij218HAvbgrjGRGJ3FkepAbpDQjqgQArpyU
         0m+8QWKcptT9wDaJlJZlIz5KxuwphMEsX8ULUvizXPqR2Q11hwxYOX9xaIYKtm+tqWFP
         brkaI7mDMr6ljsVu8yC4tdbWRXO2h3rX+99xw=
MIME-Version: 1.0
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 8 Feb 2011 20:31:50 +1100
Message-ID: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com>
Subject: I do not know if this is the correct place to ask about this but...
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not know if this is the correct place to ask about this but...
I have only seen the following output output twice and both times have
been when I was running a 2.6.37 kernel.

[152399.816058] [Hardware Error]: MC4_STATUS: Corrected error, other
errors lost: no, CPU context corrupt: no, CECC Error
[152399.816075] [Hardware Error]: Northbridge Error, node 0: , core:
1L3 ECC data cache error.
[152399.816086] [Hardware Error]: Transaction: RD, Type: GEN, Cache
Level: L3/GEN
[152399.816092] Disabling lock debugging due to kernel taint
[152399.816099] [Hardware Error]: Machine check events logged

I assume it is just a coincidence. Also, I am not exactly sure what
the message "means". (Yes I can read the text - but I haven't found
good documentation which describes the impact it). Note: I submitted a
bug[0] regarding 'the output' the first time this occurrence.

[0] - https://bugzilla.kernel.org/show_bug.cgi?id=27332
