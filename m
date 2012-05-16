Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2EPOgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:36:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2EPOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:36:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging tree
Date: Wed, 16 May 2012 14:33:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
References: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au> <201205161054.15610.arnd@arndb.de> <4FB3B1F3.6080102@atmel.com>
In-Reply-To: <4FB3B1F3.6080102@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161433.47416.arnd@arndb.de>
X-Provags-ID: V02:K0:OwplqlrRuRhqsLLEagQBMjcE1NdsHa81y8APYHhIEqx
 YCIhZqUaJY3zpGNrDJAU2PCjPi6eINOgIYIeSnH1HTuXDyH/Hh
 e/v794iV0NZ792+aJsBHeziPkFbC0EsP868EWLdN1mahFjKEaw
 D4hK6gXA7JRRzaZV1D3qU2z9eYxuu2k5XSVUvZH+1wK92MqVIG
 PWEjPqqhJMOUT4i3L1FSgli5vhjs2F78a79cdr8CqZTKkalhER
 x1Vv+yVRw38OOeKNecogoMsyH5HibAGhpGHlnhKBalS2vZc38c
 VeU6ACmB/FbJ16DAVP3DUn/q2GUd+hWRCmZBUlYAyicOoGSGnq
 4Aqn2u/FBgVL8Dza1kMA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Nicolas Ferre wrote:
> I am on the subject till this morning to figure out if the parameters
> are SoC dependent. It seems that the ADC is the same between those two
> platforms but the technology is different: I have to figure out the
> details internally.
> 
> I will give you a patch on top of arm-soc soon. It will replace the one
> in staging-next: does it sound good to you?

Ok, good.

	Arnd
