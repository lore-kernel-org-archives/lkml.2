Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab0ERVbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:31:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37376 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0ERVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qcJPWlCRcvPC3HHn9u6oJD/pJfGicILms4WXF0sHsaQTBHVPCAs1IMf+iJxNWtrktQ
         swy/4JPutCyewijwFJuBzK3KQ9t3mmS5RaK4OTN0mQoI2Q3bfJSgpNiBNx6a6NTIICSd
         RucZZOBjnF0JycnwHHo8f4r1GNAkIaZ7TteaY=
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using
 alternatives
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <4BF2FF82.7090005@zytor.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF82.7090005@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 23:31:00 +0200
Message-ID: <1274218260.2485.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 mai 2010 à 13:58 -0700, H. Peter Anvin a écrit :

> Here is the fallback patch if you want to test it.
> 

Thanks, kernel compiled just fine with this patch.


