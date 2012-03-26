Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2CZUcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:32:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26246 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2CZUc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:32:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6661"; a="175939965"
Message-ID: <4F70D21C.80901@codeaurora.org>
Date: Mon, 26 Mar 2012 13:31:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three
 functions
References: <201203032122.36745.chunkeey@googlemail.com> <4F70B25E.60505@codeaurora.org> <4F70B3B2.7090509@codeaurora.org> <201203262212.36741.rjw@sisk.pl>
In-Reply-To: <201203262212.36741.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/12 13:12, Rafael J. Wysocki wrote:
> Hmm, what other patch?  The one you send previously?

Yes.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

