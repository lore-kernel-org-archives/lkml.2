Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1KGVcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:32:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1KGVcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:32:06 -0500
Message-ID: <4EB84E4F.5020502@canonical.com>
Date: Mon, 07 Nov 2011 13:31:59 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] Input: ALPS - Remove assumptions about packet
 size
References: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com> <1320699160-28492-5-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1320699160-28492-5-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 12:52 PM, Seth Forshee wrote:
> In preparation for version 4 protocol support, which has 8-byte
> data packets, remove all hard-coded assumptions about packet size
> and use psmouse->pktsize instead.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

The stack allocated buffer is much cleaner :).

Acked-by: Chase Douglas <chase.douglas@canonical.com>
