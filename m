Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab0HLUpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:45:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48798 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0HLUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=F5cI4Ox0eUWy6u0bFCX8cR7MK6fv04DxfpzMhG1ic9KCXqb3uJT6HxDM6IaBI/eqoz
         +VxLD1fbCtj+5QdQg+sNsUHmrIFHma1jOCHItD3ED40IDHpu3DEpyvmvhq3mbgcl/mXD
         YYMIC6ybqfdD3/Xiedd+N9TmsmQuPXfGdqZEk=
Subject: [REGRESSION 2.6.35+] 3D is broken on GeForce 8400M (NV86)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 23:45:26 +0300
Message-ID: <1281645926.3893.33.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

nouveau drivers used to work flawlessly (well, very slow, and without
powermanagment, but otherwise very stable)

Now on git master, compiz freezes after few minutes, and no traces in
kernel log once that system was able to recover.
Note that I had this problem before yesterday pull of NV0C support.


Also the already slow 3D is even slower.
(It is theoretically possible that I have sw rendering, but I _only_
updated the kernel from 2.6.35)

I tested and 2.6.35 works flawlessly with nouveau
(I still don't use it, because even on idle GPU ends being 70C, and I
don't like that - will use nouveau when weather outside will permit
that. on nvidia temperature is about 10C lower, currently 61C).


Best regards,
Maxim Levitsky

