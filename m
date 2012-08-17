Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2HQSyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:54:14 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:24891 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2HQSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:54:02 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3c7pEgsE
X-RZG-CLASS-ID: mo00
Date: Fri, 17 Aug 2012 20:53:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Subject: Re: [PATCH V3 08/14] Tools: hv: Gather DNS information
Message-ID: <20120817185353.GA14154@aepfle.de>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-8-git-send-email-kys@microsoft.com>
 <20120817165109.GA11323@kroah.com>
 <20120817173209.GA29217@decadent.org.uk>
 <20120817182721.GA7747@aepfle.de>
 <20120817184421.GD29217@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817184421.GD29217@decadent.org.uk>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, Ben Hutchings wrote:

> You are never going to have a 'works everywhere' solution for
> Linux guests.

The hook is the solution.

> How are these distribution-specific integration scripts going
> to get installed in the guesta, anyway?

The packager of the daemon will write the script, perhaps based on a
template included in tools/hv/script_xyz.sh?

Olaf
