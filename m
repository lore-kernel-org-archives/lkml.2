Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0KIH1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 02:27:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38631 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0KIH13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 02:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CXrk80crXfKiqkGcjXUzNbnG9hju4s51iDTNBIjvtKk50io/9XCSsI3XLXMShaPdYi
         6DfVvD4mgM2tols2gRNPoRfhjLe2TtrLz95/chmedO2ji+JQznrxWCinZ3rXYeI+DkFG
         ryl2OaPID7C+OF7PLiIekD62CjxyLS2ZZKy+8=
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 12:57:27 +0530
Message-ID: <AANLkTimPOAN2JSiYEQJ7VOQxVStzFxpStngZD2kepf7J@mail.gmail.com>
Subject: Doubt about CRTSCTS preprocessor macro definition in termbits.h file
From: Ramya Desai <ramya.desai@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I did not understand the CRTSCTS preprocessor macro which is defined
in termbits.h file.

http://lxr.linux.no/linux+v2.6.36/include/asm-generic/termbits.h

As per the typedefs defined in the beginning of the file, the c_cflag
is unsigned int member in the struct termios structure. The CRTSCTS is
defined in the file as a 48 bit value.

#define CRTSCTS   020000000000  /* flow control */

I saw the following snippet in one of the serial applications.

struct termios newtio;
newtio.c_cflag = B9600 | CRTSCTS | CS8 | CLOCAL | CREAD;

My question is, the c_cflag is a 32 bit value member and the CRTSCTS
is a 48 bit value. How CRTSCTS is accommodates into c_cflag variable?
Please let me know, if my interpretation is wrong.

Thanks in advance.

Regards,
Ramya.
