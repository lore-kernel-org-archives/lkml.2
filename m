Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1GDVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:12:33 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:60219 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1GDVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:12:31 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgJaAIsrEk5V5q1MPGdsb2JhbABTiQqecQsBAQEBNzKIegLBNA6GKASXPIMQiCI
X-IronPort-AV: E=Sophos;i="4.65,475,1304287200"; 
   d="scan'208";a="26761421"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 4 Jul 2011 23:14:20 +0200
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, dmitry.torokhov@gmail.com,
        chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 03/12] Input: synaptics - fix minimum reported
 ABS_TOOL_WIDTH
Message-ID: <20110704211420.GB23915@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-4-git-send-email-djkurtz@chromium.org>
 <BANLkTinX-mkjQ=qMXra5GLeMK+cb9w+9_Q@mail.gmail.com>
 <CAGS+omCXmc-4WXJDeQKY3uo8h7xBgqfZi=rmDHg2xwWK2OQxMg@mail.gmail.com>
 <BANLkTimuYi0UNjJG_mrHE+fF7UDgPSVwbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimuYi0UNjJG_mrHE+fF7UDgPSVwbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yup, good catch.  I now see that this is true for the legacy single-touch case.
> > For consistency with the existing implementation, I'm ok to drop this patch.

Thank you.

Henrik
