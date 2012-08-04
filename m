Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2HDBjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 21:39:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58419 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390Ab2HDBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 21:39:28 -0400
X-Sasl-enc: HtxdQo6rutnx8svMc+gnszOtPvkS0tlCssMHC2Ac7/wC 1344044367
Date: Fri, 3 Aug 2012 22:39:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, mjg@redhat.com,
        ibm-acpi@hmh.eng.br
Subject: Re: [PATCH] thinkpad-acpi: recognize latest V-Series using
 DMI_BIOS_VENDOR
Message-ID: <20120804013924.GA32390@khazad-dum.debian.net>
References: <1343968187-20930-1-git-send-email-manoj.iyer@canonical.com>
 <alpine.DEB.2.02.1208030005470.3041@lazy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208030005470.3041@lazy>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2012, Manoj Iyer wrote:
> Oops! This is embarrassing! my logic is flawed. Please ignore this
> patch, I will resend it

Presumably with at least one sentence to let us know how well the driver
does operate on the V-series since you want it to load there  ;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
