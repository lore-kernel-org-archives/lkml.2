Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1EALII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 07:08:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63890 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1EALHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 07:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xvV71g4A29e0wSQPS/aCuBqAC6LMuNR7QMWk8L1bc4d0tell1KHTKZ3mZBtX7vVe6N
         iRzxJGN+DkN3/EeArinQWiSmd0kEDQ8EeLgMACKZRCxd9JtIg/6XfXHoIkaj6VObzpqw
         cM1ir7NmZTZVgVE8YhCDUptx0i0ZUpPt2MP9U=
MIME-Version: 1.0
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sun, 1 May 2011 13:07:20 +0200
Message-ID: <BANLkTimkg-yDcSyzGT2_XoyuDdqJZt0-zQ@mail.gmail.com>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For anyone interested in testing these patches check them out from:

  web:   https://github.com/luciang/linux-2.6-new-sysctl
  git:   git://github.com/luciang/linux-2.6-new-sysctl.git



-- 
 .
..: Lucian
