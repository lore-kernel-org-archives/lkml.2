Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0KJTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:17:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40346 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab0KJTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=ls9QmlA0jxnL5wisjZewvkOjlsauCqyLG+xHTiFlvYzo9AGnCikIRzMw9+of5BzlhI
         /FlbOm+ByNgk2Gax64zuyKZtFBnluofFZ5tDM/V6qSFPS3WQ/JzZ8Xg8+TKPrmD8iY1f
         XPP3cEUWOuO28RuuaJuI+eCHqo+lhIAtkLdAs=
MIME-Version: 1.0
Date: Wed, 10 Nov 2010 14:17:18 -0500
X-Google-Sender-Auth: VAM6h5jKRsi2_KkW662huYaxpJ4
Message-ID: <AANLkTi=8EjNjS4=LF+LmDP-VhuiN7pgBQY+6c-zBgNXe@mail.gmail.com>
Subject: Accessibility Request
From: Thomas Stratford <tstratford@dragon-wing.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A good friend of mine (Ken Starks from the Helios Project) has come up
with a great idea that he and I think would be very useful to lots of
people in the Linux world. I was wondering if you could either:

A) Point me in the right direction to implement this.

or B) Point me to an existing project of this nature.

What Ken is looking for is: A simple macro system that would be system
wide, to map a hot key combination to a series of keystrokes. The idea
is to save time typing by mapping frequently used combinations to a
single hotkey. For example: Mapping ctrl+alt+a = "The Helios Project".

My thought was that this could be implemented in the keyboard driver
stack, and then do a simple substitution when a hot key is triggered.
Is this possible? Is there already an implementation of something like
this in the Linux world? Does this sound crazy? :)

Any help you could give would be appreciated.

Thanks,

Thomas
