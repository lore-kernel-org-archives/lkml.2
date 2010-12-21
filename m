Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0LUQij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:38:39 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56533 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0LUQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:38:38 -0500
Message-ID: <4D10D7D3.8040304@canonical.com>
Date: Tue, 21 Dec 2010 11:37:39 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: synaptics - report clickpad property
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se> <1292852364-19127-2-git-send-email-rydberg@euromail.se>
In-Reply-To: <1292852364-19127-2-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 08:39 AM, Henrik Rydberg wrote:
> With the new input property interface, it is possible to report the
> special quirks of a device using ioctl/sysfs. This patch sets up the
> device as a pointer, and reports the clickpad functionality via the
> INPUT_PROP_BUTTONPAD property.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Chase Douglas <chase.douglas@canonical.com>
