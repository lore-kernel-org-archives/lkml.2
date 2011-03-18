Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab1CRVsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:48:22 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:51806 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932590Ab1CRVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:48:14 -0400
Message-ID: <4D83D2BB.5070204@keymile.com>
Date: Fri, 18 Mar 2011 22:46:35 +0100
From: Stefan Bigler <stefan.bigler@keymile.com>
Reply-To: stefan.bigler@keymile.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com><20110317000408.GA18911@kroah.com><4D8389EC.5030704@keymile.com> <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2011 21:46:35.0803 (UTC) FILETIME=[F423F6B0:01CBE5B5]
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Returning the size of queued data is a reasonable solution for this problem.

Stefan


