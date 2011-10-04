Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1JDPJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:09:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51425 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab1JDPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:09:42 -0400
Message-ID: <4E8B21B1.1020308@lwfinger.net>
Date: Tue, 04 Oct 2011 10:09:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
References: <20111004180333.44f741dc08063a918c9b581f@canb.auug.org.au> <4E8AB741.9030707@qca.qualcomm.com> <20111004191408.8f211d359d9e5d7b65129c4c@canb.auug.org.au>
In-Reply-To: <20111004191408.8f211d359d9e5d7b65129c4c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 03:14 AM, Stephen Rothwell wrote:
>
> Since it adds an include of export.h (which only exists in Paul's tree),
> it goes into Paul's post merge patch series.

Sounds good. ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


