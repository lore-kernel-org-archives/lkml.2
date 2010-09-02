Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0IBOfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:35:04 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:53811
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755413Ab0IBOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:35:01 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz9370J98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L84J3M-02-375-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Thu, 2 Sep 2010 16:33:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35pmfix-rafael-v2+; KDE/4.5.0; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7F6931.4050707@gmail.com> <4C7F7649.3010409@gmail.com>
In-Reply-To: <4C7F7649.3010409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201009021633.22869.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 September 2010, 12:02:49 Tejun Heo wrote:
> For some mysterious reason, certain hardware reacts badly to usual EH
> actions while the system is going for suspend.  As the devices won't
> be needed until the system is resumed, ask EH to skip usual autopsy
> and recovery and proceed directly to suspend.

Thanks Tejun for this patch. Will test in a second!

Cheers,
  Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719  (AMD: 29-719)

