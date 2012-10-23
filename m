Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab2JWVun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:50:43 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49975 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab2JWVum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:50:42 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr0M7jF20=
X-RZG-CLASS-ID: mo00
Date: Tue, 23 Oct 2012 23:50:32 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: when to switch from early_ioremap to ioremap
Message-ID: <20121023215032.GA12908@aepfle.de>
References: <20121023194233.GA23588@aepfle.de>
 <CAE9FiQV-FF9F7P6s3kMBjuyR3jWZ_VFERt83UVZmc7P37gLeTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQV-FF9F7P6s3kMBjuyR3jWZ_VFERt83UVZmc7P37gLeTA@mail.gmail.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, Yinghai Lu wrote:

> Also early_ioremap has slot limitation: 4. and you should not hold one
> slot too long, otherwise other users could
> have problem to reach the limit.

Thanks. After which init call is ioremap available anymway?

Olaf
