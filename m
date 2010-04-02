Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0DBJN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:13:28 -0400
Received: from web81102.mail.mud.yahoo.com ([68.142.199.94]:39736 "HELO
	web81102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755527Ab0DBJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:13:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:To:MIME-Version:Content-Type;
  b=ELBxLD/pF9NNa1Fk5hJKzzYAGUDw1h5MAeCLSmGAhGEixgkcalVA9it3zZHYbjs+4VIpv0N4w9j0GTPXppwo4ah/hVsRINoNI2DSYGit7hUG7JOMrd2zOdmJukvo/HtNKY699BLPda4qJZb4yExqRuaOjhOkfb97FgRe/YCELsY=;
Message-ID: <420137.80667.qm@web81102.mail.mud.yahoo.com>
X-YMail-OSG: 2f6m_1AVM1kvUsTN92_Yz27Ti.YMuMJT5WmSlpJSKq9nIld
 dlCO2tVObLftB1X2Iw3lucPsNzYUVMe4Y9Dxos1TYXWtuPpX_orhmcTj_5SA
 kDls1H8NZlcpczdZYux8LyHSSzTWYhaiwVmRiVOXaXmUWDQQ8rsSlt3AAFNb
 vCh6hDa6nfJEaZWkvpCXTishv8N3SLiy2Fm0YRmovy4O_g_0MeBuJnCWCa3H
 VkHQs33.l51sOsJg6oyydeHKapIOcXrkIFjHe4Ai6iukzfovDpMZhE3woazL
 _.qfkF2lJUQBdGwK4_.obxcYCaoKm39WtsX8fzHN8.3.rpbf6jIGwlAqXYxf
 dL5.Hb8GhsYWjGFMa1Vq1yKozr0_MfIYq19C0k4P5az6Pazl3igW9wN1OjxF
 RpFqQ7g0frjAjcdZ6S7nVnnkMH1jgmgE4PwTY_HC3GRNMHjGJfQilOjDKc.O
 J0OGUN8_tIAyLKzT0mz80gJ9WB5wBXhVafICWz1ygA0NiDvfUJ38bLqxMSOk
 8mgf1P81y5z9qdnLZNMe0gKdYeO9t2p3yOYLybTOPqOicg1uRcCqjgR6iBx3
 2tYCOmSIFYiBnHcxcH2tiHT6MFdQqSn3YYIzkwCWEMvsDj0N_rtijZ0sWs5u
 G2aUAuvioEsVw_yzt1_vX1LU5aanq3W3U6QJPYh3cxB04NTnDJDEOWQ_2Q9D
 gZUQZvZJs.dzdamMaqye8z1eIgKkN0rbGWTlXtxV7azsN.YGZsX2Uk9Tdn1D
 6eJLj1S9vnO8.QqkIzyOMRPl8ix9w0iD_Mw6fniYyl.7a92ha04HHhhpspaB
 JML69WE6sH6C4k2gBg21Z1B90FCnTMAVB6lYZ.yFJalXC9WCc8hb.mi1NRlJ
 S13fic7dSMsX6l9QZ7rBBcDZT4Gn620P9IiyjO9ljg45k58niS8XiXC7HRWA
 Yu5Nf9khyhKyiWnd1qaVzGdQVSbc.lt_djcrjgxzUtruxRFsR_mFvdtdV2nc
 dgDHjp2EKTcjWdcDrv51WJzXLDCdWHD26ZgnBAth2ZnbjeRl6qKbtCNI.4PO
 C4XUBnpMJ9A4OXI_g.rqM5cZ_ITR3qDmtVmnQq6JR7h0VfnGdiUgqZCmjZMJ
 e9v1FiBSTQiPwo5JpRBtTIiA.9Dk1oeZqVm_z_SgC1LAJ9O3QUqh47mAPX05
 5f2tsxCffdpOBebFpMxMs8W7iIuolvZC5AM_68ofNFMuXLqeewE0GU_ByO.N
 J9qgM_1W13L4sS1nIK.jXqKNETwXhe35C2LHblmZO7bvCHQXSQNz_4x8mBPd
 KFhoe6RRMQfYT1e_lN7n0nwZ_Uy8hSPTeq.dt0timKD2y8CQNUzcyZkXDRPA
 xL6VaulEKofkeam0ydIFW7Q4bNUUxF7CBw3D3KxZp23_5Z02Cb7CKZHNE7pO
 rZFmovUPaLxRstczPtkzaqsr.auqmi14kXr2LweV1X9E4kkS7qgkC3JGSGi2
 4LWRhZPBW7mhx35qqaS6MF.Hki.qTGO4ytjcSO76HB5s5feuJbnKaten1Efo
 jJsVeSuLcbIM07qLEhiCWGWS7tPL2TpG1gLIWRYvGL5GnTPHzuf2pnpCadf6
 1eEnzVfYNLOOytsJCOGh5dckE8apoF5TyeZwXqjSBn3kZwm2d9bMAOQK1MuS
 7b44udrCLatXDs0TK751TfpvbJlIJIXClGKdHGvm1aOHYOPvM7my.UiWiu9B
 a5psbONC.MW3AKTIrzg53PvB1NE_zJ6bXyNXLv4iv.iMUIf0cUyAoDxI9cS1
 FQ089ujqvrMhr.Pj7cR9R67Dtn8OBfz2YumLpuezxNWFhQ09S3Q7V2.VJn3b
 i0avNm9OJIvfTM5Iw5Ybp2iv_4b2RlaQrwaI4bufP7Ym6YE8WYiWrbcaQhG5
 vHx2xbq7_K39A70MkuOTt
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 2 Apr 2010 02:13:19 -0700 (PDT)
From: Irish Online News <apurplehaze52@sbcglobal.net>
Reply-To: rsm.claim.offic@9.cn
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<br><br>You have won 891,934.00 pounds Send Necessary :name,age,occupation, country
