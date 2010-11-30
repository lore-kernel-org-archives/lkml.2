Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0K3XaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:30:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39206 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0K3XaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=CL2GMPHicwMw1DYfTPV1WUe46ud83azGLIXt1o6IKv12bhefS4UzqcyYj7Y0G7k/1T
         r+IKJ4Q12pz3MzfUwVtGaNJCgLGmbxcLKwfDOuWZeTi/1kc3LMbTaCR/AOwQWknJuaqI
         fNA46ulCTi16l9uT/GYPZD2clGm/pjL5Cc1Dc=
Message-ID: <4CF58906.4080604@doube.net>
Date: Tue, 30 Nov 2010 23:30:14 +0000
From: Michael Doube <michael@doube.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fwd: Re: [tpmdd-devel] [REGRESSION] Suspend fails because of TPM
 modules
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Is this regressions from older kernels as well?

Only inasmuch as older Ubuntu kernels loaded tpm_infineon (where suspend
was OK) and more recent ones load tpm_tis (where suspend is broken).
 I've never seen a tpm_tis that didn't break suspend on my hardware
(Vaio SZ650).

https://bugzilla.kernel.org/show_bug.cgi?id=20132
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/602049
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/657386

Michael





