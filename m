Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1FUCQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:16:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1FUCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=a2E3Pg0X/Xr6zuYOfDillCFDnaBQY4ROgHd6p7bFPGA6jd3YlK+fm74fnhsOsBdsdi
         G2zHMBxZNp7M8Yl37/5z83tZmw82R+myoj1PMjaWkh1GzIF2pfZUQFyZvKQgYlcZL7Mf
         JzCCVf6PWUiBz+tFVqaVRoGl95M3RHTTzRUaA=
MIME-Version: 1.0
From: pradeep hettiarachchi <pradeepmh@wayne.edu>
Date: Mon, 20 Jun 2011 22:15:47 -0400
X-Google-Sender-Auth: l0Qz9IzoWSC2NXecyXBZnGA5IEg
Message-ID: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com>
Subject: CPU Instantaneous Power Consumption
To: linux-kernel@vger.kernel.org, arjan@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a PhD student and doing a research which involves
control-theoretic real-time process/job scheduling. Here is my
question:

I need to calculate the power consumption of a single or two CPU cores
and equivalent Thermal Dissipation accurately. I did not find any
supporting material from Intel to find the instantaneous power
consumption (and thermal dissipation) of the CPU. Therefore I am
trying some alternative path; I measure the CPU regulator input
current (using a very small shunt resister in series with 4 pin CPU
ATX connector). Also, assuming that the CPU voltage regulator operates
at 12 V rated, I could calculate the input power to the CPU regulator.

However without knowing the following I cannot complete my power calculation:

1) What is the DC-to-DC CPU regulator efficiency ?
2) What is the relationship between TDP and input power to the CPU ?
3) Do you suggest any other better method to calculate the
instantaneous input power to the CPU ?
 (I can think of calculating accurate instantaneous CPU power as VID
(corresponding Vcc) x CPU_current_from_regulator; but, how do I read
instantaneous VID ? Is there any MSR that I can instantly access to
read VID ? (I think Intel has hidden theses details from system
developer) )

Please help me to find answers to these questions.


Sincerely,

Pradeep M. Hettiarachchi
