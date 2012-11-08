Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2KHMJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:09:37 -0500
Received: from fep16.mx.upcmail.net ([62.179.121.36]:59835 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2KHMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:09:35 -0500
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <509BA0F9.304@odi.ch>
Date: Thu, 08 Nov 2012 13:09:29 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [headache] 3.7.0-rc2 can't handle mutt (with 3.7G mail file)
 +FF (4 tabs) on a 4G memory+4 core system ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To me this looks like an issue with swap. Can you try without swap 
(swapoff)?

Ortwin
