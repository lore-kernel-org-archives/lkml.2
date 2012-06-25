Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2FYFRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:17:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41338 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310Ab2FYFRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:17:17 -0400
Message-ID: <1340601436.7758.32.camel@joe2Laptop>
Subject: Re: [PATCH] MAINTAINERS: Add entries for extcon (external
 connector) subsystem.
From: Joe Perches <joe@perches.com>
To: myungjoo.ham@gmail.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Mike Lockwood <lockwood@android.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Date: Sun, 24 Jun 2012 22:17:16 -0700
In-Reply-To: <CAJ0PZbTLEtUb0D9xvr6WQu-L6FXU6=zhx5FSKpttgtNPkXsUdw@mail.gmail.com>
References: <CAJ0PZbTLEtUb0D9xvr6WQu-L6FXU6=zhx5FSKpttgtNPkXsUdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 13:50 +0900, MyungJoo Ham wrote:
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e30a3a..c27ecab 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2704,6 +2704,14 @@ S:	Maintained
>  F:	Documentation/filesystems/ext4.txt
>  F:	fs/ext4/
> 
> +EXTERNAL CONNECTOR SUBSYSTEM (EXTCON)
> +M:	MyungJoo Ham <myungjoo.ham@samsung.com>
> +M:	Chanwoo Choi <cw00.choi@samsung.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/extcon/
> +F:	Documentation/extcon/
> +
>  Extended Verification Module (EVM)
>  M:	Mimi Zohar <zohar@us.ibm.com>
>  S:	Supported

Just a bit of trivia, it's not in alphabetic order.


