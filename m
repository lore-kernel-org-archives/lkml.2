Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0LHRqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:46:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58950 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0LHRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:46:14 -0500
Message-ID: <4CFFC45C.2040107@canonical.com>
Date: Wed, 08 Dec 2010 09:46:04 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add hovering distance axis
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 12:27 AM, Henrik Rydberg wrote:
> Touch devices capable of hovering, i.e., fingers detected a distance
> from the surface, are not supported by the current input MT
> protocol. This patch adds ABS_MT_DISTANCE, which may be used to
> indicate the distance between the contact and the surface.

Have you given thought to calling it ABS_MT_Z instead? I have no real
problem with ABS_MT_DISTANCE per se, but ABS_MT_Z is more clearly
defined in my head. If I was new to MT development I may wonder if
ABS_MT_DISTANCE had anything to do with distance between points or some
other object.

-- Chase
