Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1IPTTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:19:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38308 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1IPTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:19:03 -0400
X-Auth-Info: jZ64n40+JoLQHSeGOKdtB4DyLdglozwXshQlNmBxNKE=
Message-ID: <4E73A123.1040801@grandegger.com>
Date: Fri, 16 Sep 2011 21:18:59 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: ti_hecc: include linux/io.h
References: <1316195863-18695-1-git-send-email-zonque@gmail.com>
In-Reply-To: <1316195863-18695-1-git-send-email-zonque@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 07:57 PM, Daniel Mack wrote:
> This fixes a build breakage for OMAP3 boards.
> 
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: netdev@vger.kernel.org

Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Thanks.

Wolfgang.
