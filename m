Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0ITTql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:46:41 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:53138 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0ITTqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:46:40 -0400
In-Reply-To: <1283005748-3293-2-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-2-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
Date: Mon, 20 Sep 2010 21:46:32 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 16:29, Henrik Rydberg a écrit :

>  #define MAX_SLOTS		60
> -#define MAX_TRKID		59
> +#define MAX_TRKID		USHRT_MAX
>

Oops, I forgot this one: in the rest of the code, it seems to me that  
you use your knowledge that TRACKINGID cannot be more than 59 (you  
use it to map the tracking ID onto the slot ID). Therefore, why  
change TRKID to a larger value?

Cheers,

St.

