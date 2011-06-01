Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161160Ab1FAJlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:41:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161114Ab1FAJlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:41:35 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] usbnet/cdc_ncm: add missing .reset_resume hook
Date: Wed, 1 Jun 2011 11:43:46 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.name>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1306919630-13426-1-git-send-email-metze@samba.org> <1306919630-13426-2-git-send-email-metze@samba.org>
In-Reply-To: <1306919630-13426-2-git-send-email-metze@samba.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106011143.46667.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juni 2011, 11:13:50 schrieb Stefan Metzmacher:
> This avoids messages like this after suspend:
> 
>    cdc_ncm 2-1.4:1.6: no reset_resume for driver cdc_ncm?
>    cdc_ncm 2-1.4:1.7: no reset_resume for driver cdc_ncm?
>    cdc_ncm 2-1.4:1.6: usb0: unregister 'cdc_ncm' usb-0000:00:1d.0-1.4, CDC NCM
> 
> This is important for the Ericsson F5521gw GSM/UMTS modem.
> Otherwise modemmanager looses the fact that the cdc_ncm and cdc_acm devices
> belong together.
> 
> The cdc_ether module does the same.

Yes, it does. Have you tested this with active connections and unconnected?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
