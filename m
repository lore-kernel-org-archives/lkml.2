Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1CSUPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:15:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41693 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab1CSUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=namtrac.org; s=www;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=K2TvNSgLCBqGA6MXxUK3DxAl01/WU4kfxGQioU5xzJlzQCuR5kAL1U81Ou7YDXBbfp
         60OIsye0D+GJJ9YzM3Zg8LG0FFYEXadTovGT/aGQyBTWCh1pagilS+h7bTcbrjNXVC+z
         KfSYaGJtY74denpNPMcz9eXwJMY5HlsrrO3QU=
MIME-Version: 1.0
From: =?UTF-8?B?xLBzbWFpbCBEw7ZubWV6?= <ismail@namtrac.org>
Date: Sat, 19 Mar 2011 21:13:27 +0100
Message-ID: <AANLkTikdco2Ex_xEAgWyOQ9OytQkTqR90Nh2hOnneXSu@mail.gmail.com>
Subject: 2.6.38 kernel breaks userspace bluetooth management tools
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

According to http://www.bluez.org/the-management-interface/ bluetooth
management interface has changed in the 2.6.38 kernel and this ends up
breaking bluetooth management tools (the ones that get your bluetooth
mouse working) in both KDE & Gnome ( see
https://bugzilla.novell.com/show_bug.cgi?id=680170 ).

Now I remember there was rule like never ever break userspace tools
unless there is a good reason, right?

FWIW I got bluez 4.89 installed.

Regards,
ismail
