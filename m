Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2AMI7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:59:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46058 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2AMI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:59:01 -0500
Message-ID: <4F0FF251.70509@gmail.com>
Date: Fri, 13 Jan 2012 09:58:57 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: Use accessor for MT events
References: <1326396065-2448-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1326396065-2448-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 08:21 PM, Henrik Rydberg wrote:
> Add an accessor function for the actual MT event types, and use
> it everywhere.

Just to double check, it's only used in two places as you have below?
Your comment made me think it's used all over, and maybe you forgot to
git add files.

If everything is correct,

Reviewed-by: Chase Douglas <chase.douglas@canonical.com>
