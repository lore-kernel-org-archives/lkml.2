Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1AKCls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 21:41:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45015 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1AKClm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 21:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=nmsqwNFvhpDVw8srNZVWyFB6yQ5oMc1OG7mf0oK8Rrt4E+3zXaxE/8SstAWa/0UEz6
         x0D4rBRGtsvtOCDJ69+2a7Ss4xxwrxB1TRS1ZaBiBrR6r8IcCl2lRFFEfO8SHekIvsjE
         tTgrLWdvNaktAf8NNl+cujtmikAZXX+ZAudAw=
MIME-Version: 1.0
Date: Mon, 10 Jan 2011 18:41:41 -0800
Message-ID: <AANLkTik6c5PcC3m5LG8=0g8ecPHNzYWtsM8oy3fv955T@mail.gmail.com>
Subject: KMS and vgaconsole
From: Joshua Hudson <joshudson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone tried to implement KMS support for vgaconsole.

Not everybody wants fbcon (I most certainly do not.)

Also, having it essentially necessary for some environments
(co-existing with Xserver-xorg-radion) and unusable with others, such
as VESA in VM is not a very good situation.

This might get rid of lots of resistance to KMS.
