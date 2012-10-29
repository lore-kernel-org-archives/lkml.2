Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2J2KjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:39:19 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3385 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2J2KjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:39:18 -0400
Message-ID: <1351507155.1339.10.camel@x61.thuisdomein>
Subject: Re: [PATCH] mvsas: use correct named constants
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 11:39:15 +0100
In-Reply-To: <1348229466.1581.21.camel@x61.thuisdomein>
References: <1348229466.1581.21.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2012 10:39:16.0613 (UTC) FILETIME=[A50EAB50:01CDB5C1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 14:11 +0200, Paul Bolle wrote:
> Building the mvsas driver triggers these GCC warnings:
>     drivers/scsi/mvsas/mv_sas.c:1156:34: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
>     drivers/scsi/mvsas/mv_sas.c:1159:39: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
> 
> Silence these warnings by using the named constants from enum
> sas_device_type with the same value as the currently used named
> constants.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed these warnings while building v3.6-rc6 on current Fedora
> 17, using Fedora's default config.

Identical warnings can be seen while building v3.7-rc3. What's the
status of my patch? Did anyone found some time to have a look at it?


Paul Bolle

