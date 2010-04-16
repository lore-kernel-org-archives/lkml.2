Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0DPTsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 15:48:41 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4766 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab0DPTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 15:48:40 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] Sound not transferred to docking station after resume from StR
Date: Fri, 16 Apr 2010 21:48:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
References: <201004162131.19171.elendil@planet.nl>
In-Reply-To: <201004162131.19171.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004162148.37751.elendil@planet.nl>
X-OriginalArrivalTime: 16 Apr 2010 19:48:37.0998 (UTC) FILETIME=[CEA4A0E0:01CADD9D]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 April 2010, Frans Pop wrote:
> With 2.6.33 and earlier the sound would always come from the external
> speakers connected to the docking station. But with 2.6.34-rc4 I get
> sound still coming from the laptop's internal speakers, which is not
> correct.

Forgot to mention that sound does get transferred to the external speakers 
with .34 if I do an extra undock and redock after the resume.
