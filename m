Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1LGRMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:12:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46229 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1LGRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:12:44 -0500
Message-ID: <4EDF9E8C.6010801@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 12:12:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: teg@jklm.no
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mark some messages as INFO
References: <1323277360-3155-1-git-send-email-teg@jklm.no>
In-Reply-To: <1323277360-3155-1-git-send-email-teg@jklm.no>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/2011 12:02 PM, Tom Gundersen wrote:
> This reduces the noise in
> 
> $ dmesg --kernel --level=err,warn
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
