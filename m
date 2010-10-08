Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0JHBfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 21:35:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36568 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0JHBff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 21:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YVFCjsz2gisdUyivgtIcREhmvFOhwtqqSDwGtckb72smQVN+uKYWYGx7ocM9cdGVOy
         1eQL7qb++Vej9xaC5MWT3+FEXR7z+PCfEIC98nzC9TkPktCy0LmnwZVBvvo1o0+gikJv
         v5mktrri05bYrgT8LHqbKm28Zd09GYQXOYASk=
MIME-Version: 1.0
Date: Thu, 7 Oct 2010 21:35:33 -0400
Message-ID: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com>
Subject: [PATCH 00/33] Staging: Fixed <module-objs> to <module>-y
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I patch against the next-20101006 tree.

The patch series replace use of <module>-objs with <module>-y in the
staging directory.

Thanks,

Tracey Dent
