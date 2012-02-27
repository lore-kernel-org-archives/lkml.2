Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2B0Ooz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:44:55 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:37713 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488Ab2B0Ooy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:44:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:X-Mailer:Content-Transfer-Encoding:Message-ID:Mime-Version;
	b=mu6iJH9u43HUajH/0LvBU0TwvcTWlG04Uiqsj2zMbh/Vg3aoWjAH4dHkBr8DtbDhJ/C5RHrYaclir1A5UiDV/dPK+ETKYr32bW4HNXkyrysaOrDsRqONbfiqodYDzclD;
Subject: Re: [PATCH 2/2] HID: wacom: Add serial and id reporting for Wacom
 Intuos4 WL
From: Przemo Firszt <przemo@firszt.eu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: pinglinux@gmail.com, chris@cnpbagwell.com,
        linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Date: Mon, 27 Feb 2012 14:44:31 +0000
In-Reply-To: <alpine.LNX.2.00.1202271530390.31150@pobox.suse.cz>
References: <1330091552-9011-1-git-send-email-przemo@firszt.eu>
	 <alpine.LNX.2.00.1202271530390.31150@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 PLD Linux 
Content-Transfer-Encoding: 7bit
Message-ID: <1330353877.4870.3.camel@pldmachine>
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2012-02-27, pon o godzinie 15:30 +0100, Jiri Kosina pisze:
> On Fri, 24 Feb 2012, Przemo Firszt wrote:
> 
> > This patch implements reporting id and serial number of used tool.
> > Reported values are the same as for USB on of the driver for wacom Intuos4 W
> 
> Applied.
> 

Thanks!
-- 
Przemo

