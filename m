Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab0HECeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:34:50 -0400
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:50635 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692Ab0HECes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:34:48 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 22:34:48 EDT
From: Anjali Kulkarni <anjali@juniper.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 4 Aug 2010 19:20:04 -0700
Subject: Freebsd image from Qemu hangs on booting in KVM 
Thread-Topic: Freebsd image from Qemu hangs on booting in KVM 
Thread-Index: AQHLNETagSCU1GEtzECSKTWdUsu3Mw==
Message-ID: <50B3A5560BA4D74CADEC55A48B4641B23D5AD270D6@EMBX01-HQ.jnpr.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem similar to the one seen on this list before - when I boot my freebsd based(but modified) image in Qemu with KVM on CentOS, then after almost booting completely, the image hangs - just before the login prompt is seen. If I do not have KVM ie plain CenOS with Qemu, then this issue does not occur. Has anyone seen this before and any ideas how to debug this?

Thanks
Anjali