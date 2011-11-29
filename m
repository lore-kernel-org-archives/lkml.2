Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1K2Tbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:31:36 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33105 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1K2Tbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:31:34 -0500
Subject: Re: [PATCH] sctp: integer overflow in sctp_auth_create_key()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20111129.011932.1501413448765180498.davem@davemloft.net>
Date: Tue, 29 Nov 2011 14:31:30 -0500
Cc: linux-kernel@vger.kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BC344CCF-A50F-4E5E-A9A5-F506D8BD9DB9@gmail.com>
References: <028246D6-9024-4E43-93A1-25A87878CBBC@gmail.com> <20111129.011932.1501413448765180498.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry my bad.

BTW it seems that the patch was not applied correctly either in
the commit a5e5c374 --- it says "No differences found".

Can you please apply the new patch v2?  Thanks.

- xi

On Nov 29, 2011, at 1:19 AM, David Miller wrote:
> 
> Applied, but I had to apply your patch by hand because it was
> corrupted by your email client.
> 
> Please fix this problem because I am not applying any other patch
> you've submitted which has this issue.

