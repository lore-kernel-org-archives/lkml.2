Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1HaOth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:49:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab1HaOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:49:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 25/35] Hexagon: Implement basic cache-flush support
Date: Wed, 31 Aug 2011 16:49:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190802.092436755@codeaurora.org>
In-Reply-To: <20110830190802.092436755@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311649.32507.arnd@arndb.de>
X-Provags-ID: V02:K0:w9q1bgjPuSzjjERygUWbc5IditwmqIHm4fvaTcD0Wlw
 2NkZGX8XaD2XA7OJ4Q0QSyrzeHNrBfHhSe/AtJxI/nftlNkdQE
 G7BftJj5FC0mepNopH3pPW8QYGYZqK147wzUfyO7TE6cTHLgq7
 XHkSILRa/13vQWXGRO+3WRzjYOyY/zkQyUZ16VkCwrIfJVBpt0
 R9nVTL21QzfUvcchddwfmAQBgozWn+1TO3yXUK485IaNedafIC
 Iy1RotWZfzoCJhprtyXjX+XrIZpPnze/GSEwdgJHqwjoz4eF4F
 /rIDgKsJi8BkjUWt/LSnGxBkwabOXyTQmGBmt6l2wzcR+K3oe2
 z+7G7yt4ndAslE2fymkI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> 
> We have separate I/D caches.  Data caches are physically indexed.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
