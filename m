Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737Ab2BJSTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:19:36 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:3749 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654Ab2BJSTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:19:35 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1328897973!1775799!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.5; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Feb 2012 12:17:59 -0600
Subject: Question: Documentation/dontdiff
Thread-Topic: Question: Documentation/dontdiff
Thread-Index: AczoH/ftWEffdvAbT5yqA4xdwog92w==
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F41F9DF813@AUSP01VMBX24.collaborationhost.net>
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

Hello all,

Why is mach included in the dontdiff list?

This is causing all the arch/arm/mach-*/include/mach directories to be excluded
when doing a diff with --exclude-from=Documentation/dontdiff.

Thanks for any reply,
Hartley

