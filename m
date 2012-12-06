Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2LFB5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:57:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42501 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2LFB5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:57:09 -0500
Message-ID: <50BFFB6E.5080108@zytor.com>
Date: Wed, 05 Dec 2012 17:57:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: kexec and struct boot_params
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Could you give a list of struct boot_params field which are initialized
properly by kexec?  I think we need to do the sentinel hack, and want to
know what to whitelist.

Also, does kexec set a bootloader ID?

	-hpa
