Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0JVOWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:22:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48257 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0JVOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kuRjrBFWHCHnuVSkrTsyl5d+5ehVyxGp0/NMlF1iuboKzuRBot6JN0i+iwiJeowJen
         VXqVJIbHAoBbaLFJgk5AMPLYWKlPXxQmjUVfoStHk51macUF5Bu3+RvzOTLNkU08/JRK
         1eepFJMI53+TaPkcCGprGI90VMb9RvN2tky0A=
MIME-Version: 1.0
Date: Fri, 22 Oct 2010 12:22:06 -0200
Message-ID: <AANLkTik8kFkQTdr4nxP2hfGG0Z4EMhSwwL+6NeCq+OjA@mail.gmail.com>
Subject: Mapping Inode to File
From: Artur Baruchi <mail.baruchi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys.

Is there a way to map an Inode number to a File (file path and name)
in a kernel module ?

Thanks,

Att.
Artur Baruchi
