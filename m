Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229Ab0E0SqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:46:05 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34805 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab0E0SqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:46:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Oskar Stenman <oskar@cetex.se>
Subject: Re: eeepc_laptop - 1005PE webcam not working properly.
Date: Thu, 27 May 2010 20:36:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1274978602.10737.15.camel@oskar-laptop>
In-Reply-To: <1274978602.10737.15.camel@oskar-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272036.20558.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 27. Mai 2010 18:43:22 schrieb Oskar Stenman:
> It seems that eeepc_laptop kernel module wont recognize the webcam in my
> 1005pe, so i can't power it down as easily as i would like it to be.

Your camera is a USB video device. uvcvideo handles such devices,
not eeepc_laptop.

	Regards
		Oliver
